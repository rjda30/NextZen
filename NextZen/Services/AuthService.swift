import Foundation
import Supabase
import SwiftUI

@MainActor
final class AuthService: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    static let shared = AuthService()
    private init() {}

    func checkSession() async {
        do {
            let session = try await supabase.auth.session
            currentUser = session.user
        } catch {
            currentUser = nil
        }
    }

    func signInAnonymously() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await supabase.auth.signInAnonymously()
            currentUser = response.user
            await ensureProfile(userId: response.user.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func signUp(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await supabase.auth.signUp(email: email, password: password)
            currentUser = response.user
            await ensureProfile(userId: response.user.id)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func signIn(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        do {
            let session = try await supabase.auth.signIn(email: email, password: password)
            currentUser = session.user
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func signOut() async {
        try? await supabase.auth.signOut()
        currentUser = nil
    }

    private func ensureProfile(userId: UUID) async {
        let profileData: [String: AnyJSON] = ["id": .string(userId.uuidString), "home_name": .string("My Home")]
        try? await supabase.from("user_profiles")
            .upsert(profileData, onConflict: "id")
            .execute()
    }
}
