package steps;

import io.cucumber.java.After;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.logging.LogEntries;
import org.openqa.selenium.logging.LogType;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import static java.lang.String.*;
import static java.util.Collections.emptyList;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertFalse;

public class PageSteps extends BaseStep {
    private final static Logger LOGGER = Logger.getLogger(PageSteps.class.getName());
    private String page = "";
    private final List<String> brokenLinks = new ArrayList<>();
    private LogEntries logEntries;

    @Given("^I opened a page (.+) in (.+) browser$")
    public void iOpenedAPage(String page, String browser) {
        setup(browser);
        driver.get(page);
        this.page = page;
    }

    @And("^There were no console errors on the page load$")
    public void thereAreNoConsoleErrors() {
        logEntries = driver.manage().logs().get(LogType.BROWSER);
        assertFalse(format("The following console errors are visible on page loads:\n%s\n\n", logEntries.getAll()), logEntries.iterator().hasNext());
    }

    @And("^The response code from the page was (.+)$")
    public void theResponseCodeFromThePageWas(String responseCode) throws IOException {
        int httpResponseCode = getHttpResponseCode(page);
        assertThat("Invalid http response code", httpResponseCode, is(Integer.parseInt(responseCode)));
    }

    @When("^I verify all links on the page$")
    public void iVerifyAllLinksOnThePage() {
        verifyLinks(getAllLinksFromThePage());
    }

    @And("^There are no broken links$")
    public void thereAreNoBrokenLinks() {
        assertThat("The following links are broken: \n" + brokenLinks, brokenLinks, is(emptyList()));
        driver.quit();
    }

    private int getHttpResponseCode(String page) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) (new URL(page).openConnection());
        connection.setRequestMethod("HEAD");
        connection.connect();
        return connection.getResponseCode();
    }


    private List getAllLinksFromThePage() {
        return driver.findElements(By.tagName("a"))
                .stream()
                .map(link -> link.getAttribute("href"))
                .collect(Collectors.toList());
    }


    private void verifyLinks(List listOfLinks) {
        listOfLinks.forEach(
                link -> {
                    if (link == null || ((String) (link)).isEmpty()) {
                        System.out.println("URL is either not configured for anchor tag or it is empty");
                    } else if (((String) (link)).startsWith("mailto:") || ((String) (link)).startsWith("tel")) {
                        System.out.println("Email address or phone number detected");
                    } else {
                        verifyLink((String) link);
                    }
                });
    }


    private void verifyLink(String url) {
        try {
            getHttpResponseCode(url);
            if (getHttpResponseCode(url) >= 400) {
                System.out.print("Checking: ");
                System.out.println(url + " - broken");
                brokenLinks.add(url);
            } else {
                System.out.print("Checking: ");
                System.out.println(url + " - " + " correct");
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    @After
    public void afterScenario() {
        driver.quit();
    }


}

