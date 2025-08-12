//
//  ContentView.swift
//  Awowa
//
//  Created by Leng Trang on 8/4/25.
//

import SwiftUI
import WebKit

struct ChannelList: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let videoLink: String
}

struct ChannelSection: Identifiable {
    let id = UUID()
    let title: String
    let channels: [ChannelList]
}

struct ContentView: View {
    // Sample data
    private let sections: [ChannelSection] = [
        ChannelSection(
            title: "Songs",
            channels: [
                ChannelList(
                    name: "SuperSimpleSongs",
                    imageName: "SuperSimpleSongs", // in Assets
                    videoLink: "https://www.youtube.com/@SuperSimpleSongs"
                )
            ]
        ),
        ChannelSection(
            title: "Storytime",
            channels: [
//                ChannelList(
//                    name: "SuperSimpleSongs",
//                    imageName: "SuperSimpleSongs", // in Assets
//                    videoLink: "https://www.youtube.com/@SuperSimpleSongs"
//                )
            ]
        ),
        ChannelSection(
            title: "Other",
            channels: [
                ChannelList(
                    name: "Youtube",
                    imageName: "Youtube", // in Assets
                    videoLink: "https://www.youtube.com"
                )
            ]
        ),
        // Add more sections here...
        // ChannelSection(title: "STEM & Learning", channels: [...])
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section(section.title) {
                        // One row that contains a 2-column grid of channel cards
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(section.channels) { channel in
                                NavigationLink(destination: VideoView(videoURL: channel.videoLink)) {
                                    VStack(spacing: 8) {
                                        Image(channel.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())

                                        Text(channel.name)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                            .minimumScaleFactor(0.8)
                                            .lineLimit(2)
                                    }
                                    .frame(maxWidth: .infinity) // let the card fill its grid cell
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .buttonStyle(.plain) // avoid default List row highlighting
                            }
                        }
                        .listRowInsets(EdgeInsets()) // make the grid span full width
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Children Safe Channels")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
