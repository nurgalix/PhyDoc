struct Slot: Decodable {
    let id: Int
    let datetime: String
    let price: Int
}

struct DaySchedule {
    let date: String
    var slots: [Slot]
}

func transformSchedule(apiResponse: [String: Any]) -> [DaySchedule] {
    guard let slots = apiResponse["slots"] as? [[String: Any]] else { return [] }

    var groupedSlots: [String: [Slot]] = [:]

    for slot in slots {
        guard
            let id = slot["id"] as? Int,
            let datetime = slot["datetime"] as? String,
            let price = slot["price"] as? Int
        else { continue }

        let components = datetime.split(separator: "T")
        guard components.count == 2 else { continue }
        
        let date = String(components[0])
        let time = String(components[1].prefix(5)) // Extract HH:mm format

        let newSlot = Slot(id: id, datetime: time, price: price)
        groupedSlots[date, default: []].append(newSlot)
    }

    // Transform dictionary into a sorted array
    return groupedSlots.map { DaySchedule(date: $0.key, slots: $0.value) }
        .sorted { $0.date < $1.date }
}
