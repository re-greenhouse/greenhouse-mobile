enum CropCurrentPhase {
  formula,
  preparationArea,
  bunker,
  tunnel,
  incubation,
  casing,
  induction,
  harvest,
}

extension CropPhaseExtension on CropCurrentPhase {
  static final Map<CropCurrentPhase, String> _phaseNames = {
    CropCurrentPhase.formula: "Formula",
    CropCurrentPhase.preparationArea: "Preparation Area",
    CropCurrentPhase.bunker: "Bunker",
    CropCurrentPhase.tunnel: "Tunnel",
    CropCurrentPhase.incubation: "Incubation",
    CropCurrentPhase.casing: "Casing",
    CropCurrentPhase.induction: "Induction",
    CropCurrentPhase.harvest: "Harvest",
  };

  static final Map<CropCurrentPhase, String> _phaseNumbers = {
    CropCurrentPhase.formula: "0",
    CropCurrentPhase.preparationArea: "1",
    CropCurrentPhase.bunker: "2",
    CropCurrentPhase.tunnel: "3",
    CropCurrentPhase.incubation: "4.1",
    CropCurrentPhase.casing: "4.2",
    CropCurrentPhase.induction: "4.3",
    CropCurrentPhase.harvest: "4.4",
  };

  String get phaseName => _phaseNames[this] ?? '';
  String get phaseNumber => _phaseNumbers[this] ?? '';
}
