using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace postgreproje
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=VTYS; user ID=postgres; password=6100");


        private void BtnListele_Click(object sender, EventArgs e)
        {
            baglanti.Open();

            // Mahkemekisi tablosunu "Mahkeme" tablosu ile birleştirme
            string sorgu = "SELECT " +
                "\"public\".\"Mahkeme\".\"MahkemeNo\", " +
                "\"public\".\"Mahkeme\".\"MahkemeAdi\", " +
                "\"public\".\"Mahkeme\".\"AdresNo\", " +
                "\"public\".\"MahkemeKisi\".\"ToplamKisi\", " +
                "\"public\".\"MahkemeKisi\".\"PersonalSayisi\" " +
                "FROM \"public\".\"Mahkeme\" " +
                "LEFT JOIN \"public\".\"MahkemeKisi\" ON \"public\".\"Mahkeme\".\"MahkemeNo\" = \"public\".\"MahkemeKisi\".\"MahkemeNo\"";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);

            // Mahkeme no'ya göre gruplayarak tekrarları önleme
            DataTable dt = ds.Tables[0];
            var query = from row in dt.AsEnumerable()
                        group row by row.Field<int>("MahkemeNo") into g
                        select g.First();

            // Yeni dataset oluşturup gruplanmış verileri ekleme
            DataSet yeniDs = new DataSet();
            DataTable yeniDt = query.CopyToDataTable();
            yeniDs.Tables.Add(yeniDt);

            dataGridView1.DataSource = yeniDs.Tables[0];
            baglanti.Close();
        }

        private void BtnEkle_Click(object sender, EventArgs e)
        {
            // Değerleri al
            int mahkemeNo = Convert.ToInt32(TxtMahkemeNo.Text);
            string mahkemeAdi = TxtAd.Text;
            int adresNo = Convert.ToInt32(TxtAdres.Text);
            int toplamKisi = Convert.ToInt32(numericUpDown2.Value);
            int personalSayisi = Convert.ToInt32(numericUpDown1.Value);

            // Ekleme sorgusu
            string ekleSorgu = "insert into \"public\".\"Mahkeme\" " +
                "(\"MahkemeNo\", \"MahkemeAdi\", \"AdresNo\") " +
                "VALUES (@MahkemeNo, @MahkemeAdi, @AdresNo)";

            string ekleKisiSorgu = "insert into \"public\".\"MahkemeKisi\" " +
                "(\"MahkemeNo\", \"ToplamKisi\", \"PersonalSayisi\") " +
                "VALUES (@MahkemeNo, @ToplamKisi, @PersonalSayisi)";

            // Parametreleri oluştur
            NpgsqlCommand ekleKomut = new NpgsqlCommand(ekleSorgu, baglanti);
            ekleKomut.Parameters.AddWithValue("@MahkemeNo", mahkemeNo);
            ekleKomut.Parameters.AddWithValue("@MahkemeAdi", mahkemeAdi);
            ekleKomut.Parameters.AddWithValue("@AdresNo", adresNo);

            NpgsqlCommand ekleKisiKomut = new NpgsqlCommand(ekleKisiSorgu, baglanti);
            ekleKisiKomut.Parameters.AddWithValue("@MahkemeNo", mahkemeNo);
            ekleKisiKomut.Parameters.AddWithValue("@ToplamKisi", toplamKisi);
            ekleKisiKomut.Parameters.AddWithValue("@PersonalSayisi", personalSayisi);

            try
            {
                // Bağlantıyı aç
                baglanti.Open();

                // Mahkeme tablosuna ekle
                ekleKomut.ExecuteNonQuery();

                // MahkemeKisi tablosuna ekle
                ekleKisiKomut.ExecuteNonQuery();

                // Listeyi güncelle
                BtnListele_Click(sender, e);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
            finally
            {
                // Bağlantıyı kapat
                baglanti.Close();
            }
        }


        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }
    }
}
