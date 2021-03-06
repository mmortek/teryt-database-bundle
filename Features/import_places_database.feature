Feature: Parse places xml file and import data into database

  Background:
    Given I successfully run console command "doctrine:schema:create"

  Scenario: Import places from xml file
    Given "places.xml" file have following content:
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <teryt>
      <catalog name="SIMC" type="all" date="2013-03-06">
        <row>
          <col name="WOJ">04</col>
          <col name="POW">11</col>
          <col name="GMI">05</col>
          <col name="RODZ_GMI">5</col>
          <col name="RM">01</col>
          <col name="MZ">1</col>
          <col name="NAZWA">Rzeczyca</col>
          <col name="SYM">0867650</col>
          <col name="SYMPOD">0867650</col>
          <col name="STAN_NA">2013-03-06</col>
        </row>
      </catalog>
    </teryt>
    """
    And following province was already imported
      | Code | Name               |
      | 04   | KUJAWSKO-POMORSKIE |
    And following district was already imported
      | Code | Name         | Province           |
      | 0411 | RADZIEJOWSKI | KUJAWSKO-POMORSKIE |
    And places table in database is empty
    And there is a place type with type "01" and name "wieś"
    And there is a community in database with code "0411055" and name "Gmina Rzerzyca" in district "RADZIEJOWSKI"
    When I successfully run console command "teryt:import:places" with argument "--file=teryt/places.xml"
    Then places table in database should have following records
      | Identity | Name     | Place type | Community      |
      | 0867650  | Rzeczyca | wieś       | Gmina Rzerzyca |

  Scenario: Update place during import
    Given "places.xml" file have following content:
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <teryt>
      <catalog name="SIMC" type="all" date="2013-03-06">
        <row>
          <col name="WOJ">04</col>
          <col name="POW">11</col>
          <col name="GMI">05</col>
          <col name="RODZ_GMI">5</col>
          <col name="RM">01</col>
          <col name="MZ">1</col>
          <col name="NAZWA">Rzeczyca Górna</col>
          <col name="SYM">0867643</col>
          <col name="SYMPOD">0867643</col>
          <col name="STAN_NA">2013-03-06</col>
        </row>
        <row>
          <col name="WOJ">04</col>
          <col name="POW">11</col>
          <col name="GMI">05</col>
          <col name="RODZ_GMI">5</col>
          <col name="RM">01</col>
          <col name="MZ">1</col>
          <col name="NAZWA">Rzeczyca</col>
          <col name="SYM">0867650</col>
          <col name="SYMPOD">0867643</col>
          <col name="STAN_NA">2013-03-06</col>
        </row>
      </catalog>
    </teryt>
    """
    And following province was already imported
      | Code | Name               |
      | 04   | KUJAWSKO-POMORSKIE |
    And following district was already imported
      | Code | Name         | Province           |
      | 0411 | RADZIEJOWSKI | KUJAWSKO-POMORSKIE |
    And places table in database is empty
    And there is a place type with type "01" and name "wieś"
    And there is a community in database with code "0411055" and name "Gmina Rzerzyca" in district "RADZIEJOWSKI"
    Then following place should exist in database
      | Identity | Name           | Place type | Community      |
      | 0867643  | RZECZYCA GÓRNA | wieś       | Gmina Rzerzyca |
      | 0867650  | RZECZYCA       | wieś       | Gmina Rzerzyca |
    When I successfully run console command "teryt:import:places" with argument "--file=teryt/places.xml"
    Then places table in database should have following records
      | Identity | Name           | Parent place   | Place type | Community      |
      | 0867643  | Rzeczyca Górna |                | wieś       | Gmina Rzerzyca |
      | 0867650  | Rzeczyca       | Rzeczyca Górna | wieś       | Gmina Rzerzyca |
