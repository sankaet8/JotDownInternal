import SwiftUI
import SwiftData

enum SearchMode: String, CaseIterable, Identifiable {
    case regexContains = "Regex/Contains"
    case foundationModels = "Foundation Models"
    case rag = "RAG"

    var id: Self { self }
}

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Thought.dateCreated, order: .reverse) private var thoughts: [Thought]

    @State private var searchText: String = ""
    @State private var mode: SearchMode = .regexContains
    @State private var results: [Thought] = []
    @State private var isSearching: Bool = false
    @State private var hasSearched: Bool = false

    var body: some View {
        List(results) { thought in
            VStack(alignment: .leading) {
                HStack {
                    Text(thought.dateCreated, style: .date)
                    Spacer()
                    if let category = thought.category {
                        Text(category.title)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(thought.text)
            }
        }
        .listStyle(.plain)
        .searchable(
            text: $searchText,
            placement: .automatic,
            prompt: "Search thoughts"
        )
        .overlay {
            if searchText.isEmpty {
                ContentUnavailableView(
                    "Search",
                    systemImage: "magnifyingglass",
                    description: Text("Enter a query to search your thoughts.")
                )
            } else if results.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
        .onChange(of: searchText) { _, _ in
            if !searchText.isEmpty {
                performSearch()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Mode", selection: $mode) {
                    Text("Regex/Contains").tag(SearchMode.regexContains)
                    Text("Foundation Models").tag(SearchMode.foundationModels)
                    Text("RAG").tag(SearchMode.rag)
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle("Search")
    }

    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            results = []
            hasSearched = false
            return
        }
        hasSearched = true

        switch mode {
        case .regexContains:
            results = searchRegexContains(query: query, in: thoughts)
        case .foundationModels:
            isSearching = true
            Task {
                let r = await searchFoundationModels(query: query, in: thoughts)
                await MainActor.run {
                    results = r
                    isSearching = false
                }
            }
        case .rag:
            isSearching = true
            Task {
                let r = await searchRAG(query: query, in: thoughts)
                await MainActor.run {
                    results = r
                    isSearching = false
                }
            }
        }
    }

    // MARK: - Search Implementations

    private func searchRegexContains(query: String, in thoughts: [Thought]) -> [Thought] {
        if let regex = try? Regex(query, as: Substring.self) {
            return thoughts.filter { thought in
                thought.text.contains(regex)
            }
        } else {
            return thoughts.filter { thought in
                thought.text.localizedCaseInsensitiveContains(query)
            }
        }
    }

    private func searchFoundationModels(query: String, in thoughts: [Thought]) async -> [Thought] {
        try? await Task.sleep(nanoseconds: 150_000_000)
        return thoughts.first.map { [$0] } ?? []
    }

    private func searchRAG(query: String, in thoughts: [Thought]) async -> [Thought] {
        thoughts.first.map { [$0] } ?? []
    }
}

#Preview {
    SearchView()
}
