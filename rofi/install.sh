export CONFIG_DIR="~/.config/rofi"
export THEMES_DIR="~/.local/share/rofi/themes"

mkdir -p ${CONFIG_DIR}
mkdir -p ${THEMES_DIR}

cp -v config.rasi ${CONFIG_DIR}
cp -v catppuccin.rasi ${THEMES_DIR}

