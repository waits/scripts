require "http"

URL = "https://www.alaskaair.com/search/api/flightresults"
BODY = {
    "origins": [
        "sfo"
    ],
    "destinations": [
        "tpe"
    ],
    "dates": [
        "2025-07-24"
    ],
    "numADTs": 1,
    "numINFs": 0,
    "numCHDs": 0,
    "fareView": "None",
    "onba": false,
    "dnba": false,
    "discount": {
        "code": "",
        "status": 0,
        "expirationDate": "2025-07-22T19:08:49.462Z",
        "message": "",
        "memo": "",
        "type": 0,
        "searchContainsDiscountedFare": false,
        "campaignName": "",
        "campaignCode": "",
        "distribution": 0,
        "amount": 0,
        "validationErrors": [],
        "maxPassengers": 0
    },
    "isAlaska": false,
    "isMobileApp": false,
    "isWholeTripPricing": false,
    "sliceId": 0,
    "businessRequest": {
        "TravelerId": "",
        "BusinessRequestType": 0,
        "CountryCode": "",
        "StateCode": "",
        "ShowOnlySpecialFares": false
    },
    "umnrAgeGroup": "",
    "lockFare": false,
    "sessionID": "",
    "solutionIDs": [],
    "solutionSetIDs": [],
    "qpxcVersion": "",
    "trackingTags": [],
    "isMultiCityAwards": false
}

HTTP.post(URL)