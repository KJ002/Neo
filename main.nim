import strutils, json, httpclient, nancy, constants, math

proc getPage(pageNum: int = 0): JsonNode =
    let
        client = newHttpClient()
        data = parseJson(client.getContent(
                "https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=$#&page=$#" %
                [TOKEN, $pageNum]))

    return data

proc getBodies(pageMax: int = 1): seq[JsonNode] =
    var data: JsonNode

    for i in 0..pageMax-1:
        data = getPage i

        for body in data["near_earth_objects"].getElems():
            result.add body

proc parseBodies(data: JsonNode): seq[string] =
    result.add data["name"].getStr

    if data["is_potentially_hazardous_asteroid"].getBool:
        result.add "Yes"

    if not data["is_potentially_hazardous_asteroid"].getBool:
        result.add "No"

    var diamerter: float = data["estimated_diameter"]["meters"][
            "estimated_diameter_max"].getFloat - data["estimated_diameter"][
            "meters"]["estimated_diameter_min"].getFloat

    result.add $(round diamerter).toInt

proc main() =
    var table: TerminalTable
    table.add "Name", "Hazardous", "Diameter (m)"

    for i in getBodies():
        table.add(parseBodies(i))

    table.echoTableSeps(80, boxSeps)

when isMainModule:
    main()
