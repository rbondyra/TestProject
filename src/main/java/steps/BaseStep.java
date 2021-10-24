package steps;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.logging.LogType;
import org.openqa.selenium.logging.LoggingPreferences;
import org.openqa.selenium.remote.CapabilityType;

import java.util.logging.Level;

public abstract class BaseStep {
    protected WebDriver driver;

    public BaseStep() {
    }

    protected void setup(String browser) {
        System.setProperty("webdriver.gecko.driver", "C:\\Desktop\\driver\\geckodriver.exe");
        System.setProperty("webdriver.chrome.driver", "C:\\Desktop\\driver\\chromedriver.exe");

        LoggingPreferences logPrefs = new LoggingPreferences();
        logPrefs.enable(LogType.BROWSER, Level.SEVERE);

        switch (browser.toUpperCase()) {
            case "FIREFOX":
                FirefoxOptions firefoxOptions = new FirefoxOptions();
                firefoxOptions.setHeadless(true);
                firefoxOptions.setCapability("marionette", true);
                driver = new FirefoxDriver(firefoxOptions);
                break;

            case "CHROME":
                ChromeOptions chromeOptions = new ChromeOptions();
                chromeOptions.setCapability(CapabilityType.LOGGING_PREFS, logPrefs);
                chromeOptions.addArguments("--no-sandbox");
                driver = new ChromeDriver(chromeOptions);
                break;

            default:
                throw new RuntimeException("Unsupported browser");
        }

    }
}
