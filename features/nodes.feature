Feature: Node list

Background:
  Given a Chef server populated with following data:
    """json
      {
        "nodes": {
          "some-node-name": {
            "automatic": {
              "fqdn": "some-node-name.example.com",
              "ipaddress": "1.2.3.4"
            }          },
          "another-node-name": {
            "automatic": {
              "fqdn": "another-node-name.example.com",
              "ipaddress": "1.2.3.5"
            }
          }
        }
      }
    """

  Given a node is populated with following data:
    """json
      {
        "automatic": {
          "languages": {
            "ruby": {
              "version": ["1.9.3", "2.0.0"],
              "host_vendor": "unknown"
            }          }
            }
      }
    """

Scenario: List of node names
  When I visit "/nodes"
  Then I can see "some-node-name"
  And I can see "another-node-name"

Scenario: selecting a node
  When I visit "/nodes"
  And I click on "some-node-name"
  Then I am at "/node/some-node-name"
  And I can see "1.2.3.4"
  And I can see "some-node-name.example.com"
  
Scenario: List of node attributes
  When I visit "/nodes"
  And I click on "some-node-name"
  Then I am at "/node/some-node-name"
  And I can see "$.automatic.languages.ruby.version[0] = "1.9.3""
  And I can see "$.automatic.languages.ruby.version[1] = "2.0.0""
