class WalletsModel {
  String? nominal;
  String? keterangan;
  String? tipe;
  String? tanggal;

  Map<String, dynamic> toMap() {
    return {
      'nominal': nominal,
      'keterangan': keterangan,
      'tipe': tipe,
      'tanggal': tanggal,
    };
  }
  
}