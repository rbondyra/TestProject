Feature: Web Test scenarios

  Create a project on Github that has the following elements:
  - Does not mention the name “...” in its title or filenames
  - Dockerized for ease of distribution and updating of tests
  - Written in Java / Cucumber
  - Use Selenium and any additionally needed frameworks
  - Runs both Firefox and Chrome
  - Browses a selection of pages on the "..." site and validates the following:
  - There are no console errors on page loads (chrome minimum)
  - The response code from the page (200, 302, 404, etc.)
  - All links on the page go to another live (non 4xx) page (no need to actually parse
  the linked page/image).

  - Pages to browse:
  - https://www.w3.org/standards/badpage
  - https://www.w3.org/standards/webofdevices/multimodal
  - https://www.w3.org/standards/webdesign/htmlcss
  - Report the results of the scan.

  Scenario Outline: Create - Read - Update operation on the articles
    Given I opened a page <Page> in Chrome browser
    And There were no console errors on the page load
    And The response code from the page was <ResponseCode>
    When I verify all links on the page
    Then There are no broken links
    Examples:
      | Page                                                 | ResponseCode |
      | https://www.w3.org/standards/badpage                 | 404          |
      | https://www.w3.org/standards/webofdevices/multimodal | 200          |
      | https://www.w3.org/standards/webdesign/htmlcss       | 200          |

  Scenario Outline: Create - Read - Update operation on the articles
    Given I opened a page <Page> in Firefox browser
    And The response code from the page was <ResponseCode>
    When I verify all links on the page
    Then There are no broken links
    Examples:
      | Page                                                 | ResponseCode |
      | https://www.w3.org/standards/badpage                 | 404          |
      | https://www.w3.org/standards/webofdevices/multimodal | 200          |
      | https://www.w3.org/standards/webdesign/htmlcss       | 200          |
