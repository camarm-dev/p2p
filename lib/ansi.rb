require './lib/storage/utils'

SETTINGS = Storage::read('settings')

if SETTINGS.key?('emojis')
  EMOJIS = SETTINGS['emojis']
else
  EMOJIS = 'fancy'
  SETTINGS['emojis'] = EMOJIS
  Storage::write(SETTINGS, 'settings')
end

$GREY = "\e[2m"
$RED = "\e[31m"
$GREEN = "\e[32m"
$YELLOW = "\e[33m"
$RESET = "\e[0m"
$BOLD = "\e[1m"
$UNDERLINE = "\e[4m"
$CLEAR = "\e[A\e[K"

# Next constants define emojis for each configuration type. Their named like CONnection / CONnectionSucess / CONnectionFail : CON / CON_S / CON_F or 4 letter (CLIP)

s = '✔️'
f = '✖️'

if EMOJIS == "fancy"
  $CON = "ᯤ"
  $CON_S = "ᯤ#{s}"
  $CON_F = "ᯤ#{f}"

  $CLIP = "📎"
  $CLIP_S = "📎#{s}"
  $CLIP_F = "📎#{f}"

  $FIRE = "💥"
  $FIRE_S = "💥#{s}"
  $FIRE_F = "💥#{f}"

  $DIR = "📂"
  $DIR_S = "📂#{s}"
  $DIR_F = "📂#{f}"

  $WORLD = "🌐"
  $PAPER = "📃️"


else
  $CON = ""
  $CON_S = "#{s}"
  $CON_F = "#{f}"

  $CLIP = ""
  $CLIP_S = "#{s}"
  $PAC_F = "#{f}"

  $FIRE = ""
  $FIRE_S = "#{s}"
  $FIRE_F = "#{f}"

  $DIR = ""
  $DIR_S = "#{s}"
  $DIR_F = "#{f}"


  $WORLD = ""
  $PAPER = ""

end

