import ArgumentParser

@main
struct EDIDRead: ParsableCommand {
    @Argument()
    var value: String
    func run() throws {
        print(value)
    }
}

