//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 31.01.2021.
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var sortOrder = Item.SortOrder.optimized
    @State private var showSortOrder = false
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
            ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var projectsEmpty: some View {
        Text("There's nothing here right now.")
            .foregroundColor(.secondary)
    }
    
    var projectsList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.items(sortedBy: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { delete($0, from: project) }
                    
                    if !showClosedProjects {
                        Button(action: { addItem(to: project) },
                               label: { Label("Add New Item", systemImage: "plus") })
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !showClosedProjects {
                Button(action: addProject,
                       label: {
                        // In iOS 14.3 VoiceOver has a bug that reads the label
                        // "Add Project" as "Add" no metter what accessibility label
                        // we give this toolbar button when using a Label.
                        // As a result when VoiceOver is running, we use a text view for
                        // the button instead, forcing a correct reading without losing
                        // the original layout.
                        if UIAccessibility.isVoiceOverRunning {
                            Text("Add Project")
                        } else {
                            Label("Add Project", systemImage: "plus")
                        }
                       }
                )
            }
        }
    }
    
    var sortProjectsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { showSortOrder.toggle()},
                   label: { Label("Sort", systemImage: "arrow.up.arrow.down") })
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    projectsEmpty
                } else {
                    projectsList
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortProjectsToolbarItem
            }
            .actionSheet(isPresented: $showSortOrder) {
                ActionSheet(title: Text("Sort items"),
                            message: nil,
                            buttons: [
                                .default(Text("Optimized")) { sortOrder = .optimized },
                                .default(Text("Creation Date")) { sortOrder = .creationDate },
                                .default(Text("Title")) { sortOrder = .title },
                                .cancel()
                            ])
            }
            
            SelectorView()
        }
    }
    
    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.items(sortedBy: sortOrder)
        offsets.forEach { dataController.delete(allItems[$0]) }
        dataController.save()
    }
    
    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            dataController.save()
        }
    }
    
    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

struct ItemRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(
            destination: EditItemView(item: item),
            label: { Label(title: { text }, icon: { icon }) }
        )
        .accessibilityLabel(label)
    }
    
    var label: Text {
        if item.completed {
            return Text("\(item.itemTitle), completed.")
        } else if item.priority == 3 {
            return Text("\(item.itemTitle), high priority.")
        } else {
            return Text(item.itemTitle)
        }
    }
    
    private var icon: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    private var text: some View {
        Text(item.itemTitle)
    }
}
