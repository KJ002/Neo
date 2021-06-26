import strutils, json, httpclient, nancy, constants, math

type
    Client = object
        http: HttpClient
        table: TerminalTable

proc init(self: var Client) =
    self.http = newHttpClient()
    self.table.add "ID", "Name", "Hazardous", "Diameter (m)"

proc getPage(self: var Client, pageNum: int = 0): JsonNode =
    return parseJson(self.http.getContent(
                    "https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=$#&page=$#" %
                    [TOKEN, $pageNum]))

proc getBodies(self: var Client, pageMax: int = 1): seq[JsonNode] =
    var data: JsonNode

    for i in 0..pageMax-1:
        data = self.getPage i

        for body in data["near_earth_objects"].getElems():
            result.add body

proc parseBodies(self: var Client, data: JsonNode): seq[string] =
    result.add data["id"].getStr

    result.add data["name"].getStr

    if data["is_potentially_hazardous_asteroid"].getBool:
        result.add "Yes"

    if not data["is_potentially_hazardous_asteroid"].getBool:
        result.add "No"

    var diamerter: float = data["estimated_diameter"]["meters"][
            "estimated_diameter_max"].getFloat - data["estimated_diameter"][
            "meters"]["estimated_diameter_min"].getFloat

    result.add $(round diamerter).toInt

proc populateTable(self: var Client) =
    for i in self.getBodies():
        self.table.add(self.parseBodies(i))

proc main() =
    var neoClient = Client()
    neoClient.init()
    neoClient.populateTable()

    neoClient.table.echoTableSeps(80, boxSeps)

when isMainModule:
    main()
