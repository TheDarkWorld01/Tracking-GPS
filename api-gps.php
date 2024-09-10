<?php
// Mengatur header agar API menerima request dari mana saja
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Koneksi ke database (sesuaikan dengan pengaturan database Anda)
$host = 'localhost';
$dbname = '';
$username = 'root';
$password = '';

try {
    // Membuat koneksi PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Cek metode request
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Mengambil data yang dikirimkan dari ESP32
        $latitude = isset($_POST['latitude']) ? $_POST['latitude'] : null;
        $longitude = isset($_POST['longitude']) ? $_POST['longitude'] : null;

        // Memeriksa apakah data latitude dan longitude tersedia
        if ($latitude && $longitude) {
            // Query untuk menyimpan data ke database
            $sql = "INSERT INTO gps (latitude, longitude) VALUES (:latitude, :longitude)";
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':latitude', $latitude);
            $stmt->bindParam(':longitude', $longitude);

            // Eksekusi query
            if ($stmt->execute()) {
                // Mengirimkan response berhasil
                http_response_code(200);
                echo json_encode(["message" => "Data berhasil disimpan."]);
            } else {
                // Mengirimkan response gagal
                http_response_code(500);
                echo json_encode(["message" => "Gagal menyimpan data."]);
            }
        } else {
            // Response jika data tidak lengkap
            http_response_code(400);
            echo json_encode(["message" => "Data latitude dan longitude diperlukan."]);
        }
    } elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Query untuk mengambil satu data terakhir dari database
        $sql = "SELECT latitude, longitude FROM gps ORDER BY id_gps DESC LIMIT 1";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();

        // Mengambil data sebagai array asosiatif
        $data = $stmt->fetch(PDO::FETCH_ASSOC);

        // Mengecek apakah ada data yang ditemukan
        if ($data) {
            // Mengirimkan data dalam format JSON
            http_response_code(200);
            echo json_encode($data);
        } else {
            // Jika tidak ada data ditemukan
            http_response_code(404);
            echo json_encode(["message" => "Tidak ada data yang ditemukan."]);
        }
    } else {
        // Response jika metode request tidak valid
        http_response_code(405);
        echo json_encode(["message" => "Metode request tidak valid."]);
    }
} catch (PDOException $e) {
    // Menangani kesalahan koneksi database
    http_response_code(500);
    echo json_encode(["message" => "Koneksi database gagal: " . $e->getMessage()]);
}
?>
