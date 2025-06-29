import SwiftUI

struct TaskSelectionView: View {
    
    @State private var selectedTasks: Set<String> = []
    @State private var petName = ""
    @State private var selectedType = ""
    
    let allTasks = ["Feed", "Water", "Walk", "Go to Park", "Brush", "Play", "Clean Litter", "Grooming"]
    let petTypes = ["Dog", "Cat"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("What does your pet do each day?")
                        .font(.title2)
                        .bold()
                    
                    Text("Choose the daily tasks you want to track")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(allTasks, id: \.self) { task in
                            TaskButton(task: task, isSelected: selectedTasks.contains(task)) {
                                withAnimation {
                                    if selectedTasks.contains(task) {
                                        selectedTasks.remove(task)
                                    } else {
                                        selectedTasks.insert(task)
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider().padding(.vertical)
                    
                    Text("Optional")
                        .font(.headline)
                    
                    TextField("Pet's Name", text: $petName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        ForEach(petTypes, id: \.self) { type in
                            Button(action: {
                                withAnimation {
                                    selectedType = type
                                }
                            }) {
                                Text(type)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(selectedType == type ? Color.black : Color.clear)
                                    .foregroundColor(selectedType == type ? .white : .black)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black.opacity(0.4), lineWidth: 1)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ChecklistView(tasks: Array(selectedTasks), petName: petName, petType: selectedType)) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(25)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        let previousTasks = Set(UserDefaults.standard.stringArray(forKey: "taskList") ?? [])
                        if previousTasks != selectedTasks {
                            UserDefaults.standard.set(Array(selectedTasks), forKey: "taskList")
                            UserDefaults.standard.removeObject(forKey: "taskProgress")
                        }
                    })
                }
                .padding()
            }
            .navigationTitle("PetPal")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadPreviousTasks()
            }
        }
    }
    
    func loadPreviousTasks() {
        if let savedTasks = UserDefaults.standard.stringArray(forKey: "taskList") {
            selectedTasks = Set(savedTasks)
        }
    }
}

struct TaskButton: View {
    let task: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconForTask(task))
                Text(task)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.black : Color.clear)
            .foregroundColor(isSelected ? .white : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut, value: isSelected)
        }
    }
    
    func iconForTask(_ task: String) -> String {
        switch task {
        case "Feed": return "takeoutbag.and.cup.and.straw.fill"
        case "Water": return "drop"
        case "Walk": return "figure.walk"
        case "Go to Park": return "leaf"
        case "Brush": return "scissors"
        case "Play": return "sportscourt"
        case "Grooming": return "comb"
        case "Clean Litter": return "trash"
        default: return "pawprint"
        }
    }
}

#Preview{
    TaskSelectionView()
}
