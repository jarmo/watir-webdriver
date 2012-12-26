#/bin/sh

set -e
set -x

sleep 20m

CHROME_REVISION=142910
sh -e /etc/init.d/xvfb start && git submodule update --init

if [[ "$WATIR_WEBDRIVER_BROWSER" = "chrome" ]]; then
  sudo apt-get install -y unzip libxss1
  curl -L -O "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux/$CHROME_REVISION/chrome-linux.zip"
  unzip chrome-linux.zip
  curl -L "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Linux/$CHROME_REVISION/chrome-linux.test/chromedriver" > chrome-linux/chromedriver
  chmod +x chrome-linux/chromedriver
fi

if [[ "$WATIR_WEBDRIVER_BROWSER" = "phantomjs" ]]; then
  sudo apt-get install build-essential chrpath git-core libssl-dev libfontconfig1-dev
  cd ext/phantomjs
  ./build.sh --confirm --jobs 1
  PATH=$PATH:$PWD/bin/
  chmod +x bin/phantomjs
  cd ../../
fi
