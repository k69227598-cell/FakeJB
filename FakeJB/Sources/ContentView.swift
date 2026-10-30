import SwiftUI

struct ContentView: View {
    @State private var progress: Double = 0
    @State private var running = false
    @State private var done = false
    @State private var logLines: [String] = []
    @State private var statusText = "Ready"
    @State private var tweaksOn = true
    @State private var restoreRootFS = false

    private let steps: [(Double, String, String)] = [
        (0.05, "Initializing...", "[*] Zenith 1.0 starting up"),
        (0.12, "Checking device...", "[*] Device: iPhone, checking compatibility"),
        (0.20, "Grabbing kernel base...", "[+] kernel_base = 0xfffffff007004000"),
        (0.30, "Patching sandbox...", "[+] sandbox patch applied"),
        (0.42, "Escaping container...", "[+] container escape ok"),
        (0.55, "Remounting rootfs...", "[*] remounting / as read-write"),
        (0.68, "Installing bootstrap...", "[*] extracting bootstrap.tar"),
        (0.80, "Setting up loader...", "[+] launchd hooks installed"),
        (0.92, "Finalizing...", "[*] cleaning up"),
        (1.00, "Done", "[+] jailbreak complete (just kidding, this is a prank)")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.06, blue: 0.12),
                                    Color(red: 0.10, green: 0.04, blue: 0.20)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Zenith")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 24)

                Text("Semi-untethered jailbreak for iOS 15 - 17")
                    .font(.footnote)
                    .foregroundColor(.gray)

                VStack(spacing: 6) {
                    HStack {
                        Text(statusText)
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundColor(.cyan)
                    }
                    ProgressView(value: progress)
                        .tint(.cyan)
                }
                .padding(.horizontal)

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(logLines.enumerated()), id: \.offset) { i, line in
                                Text(line)
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(.green)
                                    .id(i)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                    .frame(height: 200)
                    .padding(.horizontal)
                    .onChange(of: logLines.count) { n in
                        withAnimation { proxy.scrollTo(n - 1) }
                    }
                }

                VStack(spacing: 4) {
                    Toggle("Enable tweaks", isOn: $tweaksOn)
                    Toggle("Restore RootFS", isOn: $restoreRootFS)
                }
                .foregroundColor(.white)
                .tint(.cyan)
                .disabled(running)
                .padding(.horizontal, 24)

                Button(action: start) {
                    Text(done ? "Jailbroken" : (running ? "Jailbreaking..." : "Jailbreak"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(done ? Color.green : (running ? Color.gray : Color.cyan))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .disabled(running || done)
                .padding(.horizontal)

                Text("Prank app. This does not modify your device.")
                    .font(.caption2)
                    .foregroundColor(.gray)

                Spacer()
            }
        }
    }

    private func start() {
        running = true
        done = false
        progress = 0
        logLines = []
        var delay = 0.0
        for (idx, step) in steps.enumerated() {
            delay += Double.random(in: 0.6...1.6)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.4)) { progress = step.0 }
                statusText = step.1
                logLines.append(step.2)
                if idx == steps.count - 1 {
                    running = false
                    done = true
                }
            }
        }
    }
}
