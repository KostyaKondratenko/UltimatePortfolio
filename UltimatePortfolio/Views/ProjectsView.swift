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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.items(sortedBy: sortOrder)) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete {
                            let allItems = project.projectItems
                            $0.forEach { dataController.delete(allItems[$0]) }
                            dataController.save()
                        }
                        
                        if !showClosedProjects {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !showClosedProjects {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSortOrder.toggle()},
                           label: { Label("Sort", systemImage: "arrow.up.arrow.down") })
                }
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
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(
            destination: EditItemView(item: item),
            label: { Text(item.itemTitle) }
        )
    }
}
