#/bin/sh

set -e
set -x

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
  curl -L -O "https://dl.dropbox.com/u/2731643/phantomjs/phantomjs-latest.tar.bz2"
  mkdir phantomjs
  tar -xvjf phantomjs-latest.tar.bz2 -C phantomjs
  cat phantomjs/phantomjs.version
  chmod +x phantomjs/phantomjs
  sudo cp phantomjs/phantomjs /usr/local/phantomjs/bin/phantomjs
  phantomjs --version
fi

if [[ "$WATIR_WEBDRIVER_BROWSER" = "internet_explorer" ]]; then
  sudo apt-get install -y unzip
  curl -L -O "http://saucelabs.com/downloads/Sauce-Connect-latest.zip"
  unzip -d Sauce-Connect Sauce-Connect-latest.zip
  java -version
  ruby -e "IO.popen(%Q|java -jar Sauce-Connect/Sauce-Connect.jar --readyfile sauce-connect-ready #{ENV['SAUCE_LABS_USER']} #{ENV['SAUCE_LABS_ACCESS_KEY']} 2>&1|); sleep 0.1 until File.exists?('sauce-connect-ready')"
fi
