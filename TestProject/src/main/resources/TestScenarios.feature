Feature: Validate web pages

  A test scenario where all mentioned elements are checked in the following order
    * There are no console errors on page loads (chrome minimum)
    * The response code from the page (200, 302, 404, etc.)
    * All links on the page go to another live (non 4xx) page (no need to actually parse the linked page/image).
  and if one step fails, the whole scenario is failed instantly
  (eg. if there are console errors on page loads, the test fails and the response codes or broken links are not being checked). Report contains the pages that pass or fail.

  Scenario Outline: Validate pages in Chrome browser
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

  Scenario Outline: Validate pages in Firefox browser
    Given I opened a page <Page> in Firefox browser
    And The response code from the page was <ResponseCode>
    When I verify all links on the page
    Then There are no broken links
    Examples:
      | Page                                                 | ResponseCode |
      | https://www.w3.org/standards/badpage                 | 404          |
      | https://www.w3.org/standards/webofdevices/multimodal | 200          |
      | https://www.w3.org/standards/webdesign/htmlcss       | 200          |
