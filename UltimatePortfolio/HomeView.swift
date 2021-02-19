//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 31.01.2021.
//

import CoreData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Project.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
                  predicate: NSPredicate(format: "closed = false"))
    var projects: FetchedResults<Project>
    let items: FetchRequest<Item>
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init() {
        // Construct fetch request to show 10 highest priority,
        // incomplete items from open projects
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let completed = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [completed, openPredicate])
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]
        request.fetchLimit = 10
        items = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        ItemListView("Up next", for: items.wrappedValue.prefix(3))
                        ItemListView("More to explore", for: items.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
