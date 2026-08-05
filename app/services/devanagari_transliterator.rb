# Phonetic Devanagari -> Latin transliteration for URL slugs.
# Ruby/Rails' String#parameterize doesn't handle Devanagari at all -- it has
# no transliteration rule for the script, so it just strips it, leaving
# nothing. Every slug in this app that starts from Marathi text (Person now,
# Article in Phase 09 per docs/01-glossary.md's "Latin transliteration from
# the Marathi headline") needs this.
#
# Not a full ITRANS/IAST implementation -- just enough to produce a readable,
# roughly-phonetic slug. Longest matras/consonant clusters are matched first.
class DevanagariTransliterator
  VOWELS = {
    "अ" => "a", "आ" => "aa", "इ" => "i", "ई" => "ii", "उ" => "u", "ऊ" => "uu",
    "ऋ" => "ri", "ए" => "e", "ऐ" => "ai", "ओ" => "o", "औ" => "au",
    "अं" => "an", "अः" => "ah"
  }.freeze

  MATRAS = {
    "ा" => "aa", "ि" => "i", "ी" => "ii", "ु" => "u", "ू" => "uu",
    "ृ" => "ri", "े" => "e", "ै" => "ai", "ो" => "o", "ौ" => "au"
  }.freeze

  CONSONANTS = {
    "क" => "k", "ख" => "kh", "ग" => "g", "घ" => "gh", "ङ" => "ng",
    "च" => "ch", "छ" => "chh", "ज" => "j", "झ" => "jh", "ञ" => "ny",
    "ट" => "t", "ठ" => "th", "ड" => "d", "ढ" => "dh", "ण" => "n",
    "त" => "t", "थ" => "th", "द" => "d", "ध" => "dh", "न" => "n",
    "प" => "p", "फ" => "ph", "ब" => "b", "भ" => "bh", "म" => "m",
    "य" => "y", "र" => "r", "ल" => "l", "व" => "v",
    "श" => "sh", "ष" => "sh", "स" => "s", "ह" => "h", "ळ" => "l"
  }.freeze

  DIGITS = {
    "०" => "0", "१" => "1", "२" => "2", "३" => "3", "४" => "4",
    "५" => "5", "६" => "6", "७" => "7", "८" => "8", "९" => "9"
  }.freeze

  ANUSVARA = "ं"
  CHANDRABINDU = "ँ"
  VISARGA = "ः"
  VIRAMA = "्"

  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @chars = text.to_s.chars
  end

  def call
    out = +""
    i = 0
    chars = @chars

    while i < chars.length
      ch = chars[i]

      if VOWELS.key?(ch)
        out << VOWELS[ch]
        i += 1
      elsif CONSONANTS.key?(ch)
        out << CONSONANTS[ch]
        nxt = chars[i + 1]

        if nxt == VIRAMA
          i += 2 # consonant cluster, no vowel sound -- drop the inherent "a"
        elsif MATRAS.key?(nxt)
          out << MATRAS[nxt]
          i += 2
        elsif nxt == ANUSVARA || nxt == CHANDRABINDU
          out << "an"
          i += 2
        elsif nxt == VISARGA
          out << "ah"
          i += 2
        else
          out << "a" # inherent vowel
          i += 1
        end
      elsif DIGITS.key?(ch)
        out << DIGITS[ch]
        i += 1
      elsif ch =~ /[a-zA-Z0-9]/
        out << ch
        i += 1
      else
        out << " " # anything else (punctuation, spaces) becomes a separator
        i += 1
      end
    end

    out.parameterize
  end
end
