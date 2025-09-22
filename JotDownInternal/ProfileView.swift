//
//  ProfileView.swift
//  JotDownInternal
//
//  Created by Rahul on 9/21/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var categoryGenerator = CategoryGenerator()

    @AppStorage("com.jotdown.profile") var profileText: String = ""
    @AppStorage("com.jotdown.categories") var categoriesValue = StorageValue<[Category]>([])

    @State private var error: String?
    @State private var isLoading: Bool = false
    @State private var alertPresented: Bool = false
    @State private var newCategoryTitle: String = ""

    var categories: [Category] {
        categoriesValue.value ?? []
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Profile") {
                    TextField(
                        "Describe your profile...",
                        text: $profileText,
                        axis: .vertical
                    )
                    .submitLabel(.done)
                    .font(.title3)
                    .fontDesign(.serif)
                }

                Section("Categories") {
                    addCategoryRow

                    if !categories.isEmpty {
                        ForEach(categories) { category in
                            HStack {
                                Text(category.title)
                                Text(category.id.uuidString)
                            }
                                .tag(category)
                        }
                        .onDelete { indexSet in
                            categoriesValue.value?.remove(atOffsets: indexSet)
                        }
                    }

                    generateCategoriesButton
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(role: .confirm) {
                    dismiss()
                }
            }
        }
        .alert("An Error Occured", isPresented: $alertPresented) {
            Button("OK") {}
        } message: {
            Text(error ?? "Unknown error")
        }
    }

    private var generateCategoriesButton: some View {
        Button(
            categories.isEmpty ? "Generate Categories" : "Regenerate Categories"
        ) {
            Task {
                do {
                    categoriesValue.value = try await categoryGenerator.generateCategories(for: profileText)
                } catch {
                    self.error = error.localizedDescription
                }
            }
        }
        .disabled(profileText.isEmpty)
    }

    private var addCategoryRow: some View {
        HStack(spacing: 8) {
            TextField("New category...", text: $newCategoryTitle)
                .textInputAutocapitalization(.sentences)

            Button("Add") {
                addCategory()
            }
            .buttonStyle(.borderedProminent)
            .disabled(newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    private func addCategory() {
        let title = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        if categoriesValue.value == nil {
            categoriesValue.value = []
        }
        if let current = categoriesValue.value, !current.contains(where: { $0.title.caseInsensitiveCompare(title) == .orderedSame }) {
            categoriesValue.value?.append(Category(title: title))
            newCategoryTitle = ""
        }
    }
}

#Preview {
    ProfileView()
}
