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
    let imageName: String    // asset name; can be ""
    let videoLink: String
}

struct ChannelSection: Identifiable {
    let id = UUID()
    let title: String
    let channels: [ChannelList]
}

struct ContentView: View {
    // MARK: - Sample Data
    private let sections: [ChannelSection] = [
        ChannelSection(
            title: "Songs",
            channels: [
                ChannelList(name: "Super Simple Songs", imageName: "SuperSimpleSongs",
                            videoLink: "https://www.youtube.com/@SuperSimpleSongs")
            ]
        ),
        ChannelSection(
            title: "Storytime",
            channels: [
                ChannelList(name: "Vooks", imageName: "",
                            videoLink: "https://www.youtube.com/@VooksStorybooks")
            ]
        ),
        ChannelSection(
            title: "Language",
            channels: [
                ChannelList(name: "Language for Kids:🇵🇹🇭🇷 ", imageName: "",
                            videoLink: "https://www.youtube.com/@languagesforkidsmedia"),
                ChannelList(name: "Rock & Learn: 🇨🇳", imageName: "",
                            videoLink: "https://www.youtube.com/@rocknlearn")
            ]
        ),
        ChannelSection(
            title: "Other",
            channels: [
                ChannelList(
                    name: "YouTube",
                    imageName: "",
                    videoLink: "https://www.youtube.com")
            ]
        )
    ]

    // MARK: - Grid layout (adaptive = nice on iPhone/iPad)
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24, pinnedViews: [.sectionHeaders]) {
                    ForEach(sections) { section in
                        Section {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(section.channels) { channel in
                                    NavigationLink(destination: VideoView(videoURL: channel.videoLink)) {
                                        ChannelCard(channel: channel)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                        } header: {
                            // Section header (pinned)
                            Text(section.title)
                                .font(.title3.weight(.semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.thinMaterial) // looks good when pinned
                                .background(Color(red: 0/255, green: 51/255, blue: 102/255))
                                .foregroundColor(.white)
                                .textCase(.uppercase)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("CHILDREN SAFE CHANNELS")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1) // Dark blue
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

// MARK: - Reusable Card
struct ChannelCard: View {
    let channel: ChannelList

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 100, height: 100)

                if channel.imageName.isEmpty {
                    // Simple placeholder if no asset
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .opacity(0.6)
                } else {
                    Image(channel.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            }

            Text(channel.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .lineLimit(4)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding()
//        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
#Preview {
    ContentView()
}
