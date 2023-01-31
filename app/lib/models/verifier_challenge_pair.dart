class VerifierChallengePair {
  final String verifier;
  final String challenger;

  VerifierChallengePair({required this.verifier, required this.challenger});

  factory VerifierChallengePair.fromArray(List<String> verifierChallengePair) {
    return VerifierChallengePair(
        verifier: verifierChallengePair[0],
        challenger: verifierChallengePair[1]
    );
  }
}