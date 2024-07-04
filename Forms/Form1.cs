using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace postgreproje
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=VTYS; user ID=postgres; password=6100");
        private void Form1_Load(object sender, EventArgs e)
        {
        }

        private void BtnListele_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            string sorgu = "select * from public.\"Kisi\"";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            baglanti.Close();
        }

        private void BtnEkle_Click(object sender, EventArgs e)
        {
            double a = double.Parse(comboBox1.SelectedItem.ToString());
            double b = a/10000;
            try
            {
                baglanti.Open();

                // Kullanıcının bir adres seçip seçmediğini kontrol et
                if (comboBox1.SelectedIndex != null)
                {
                    NpgsqlCommand komut = new NpgsqlCommand("INSERT INTO public.\"Kisi\" VALUES (@p1, @p2, @p3, @p4, @p5, @p6, @p7, @p8)", baglanti);
                    komut.Parameters.AddWithValue("@p1", long.Parse(TxtTcNo.Text));
                    komut.Parameters.AddWithValue("@p2", TxtAdi.Text);
                    komut.Parameters.AddWithValue("@p3", TxtSoyadi.Text);
                    komut.Parameters.AddWithValue("@p4", long.Parse(TxtTelNo.Text));
                    komut.Parameters.AddWithValue("@p5", comboBox2.Text); // "Erkek" veya "Kadın" olarak saklanabilir
                    komut.Parameters.AddWithValue("@p6", checkBox1.Checked); // Yetkiliyi boolean olarak ekledik (checkbox kullanıldı)
                    komut.Parameters.AddWithValue("@p7", checkBox2.Checked); // Vatandaşı boolean olarak ekledik (checkbox kullanıldı)
                    komut.Parameters.AddWithValue("@p8", b);

                    komut.ExecuteNonQuery();

                    MessageBox.Show("Kayıt başarıyla oluşturuldu", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Lütfen bir adres seçin", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message, "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                baglanti.Close();
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        private void button1_Click(object sender, EventArgs e) // BtnAra
        {
            baglanti.Open();

            // TxtAdi.Text içindeki metni küçük harfe dönüştür ve sorguda kullan
            string aramaKelimesi = TxtAdi.Text.ToLower();

            NpgsqlCommand komut3 = new NpgsqlCommand("SELECT * FROM public.\"Kisi\" WHERE LOWER(\"Ad\") LIKE '%" + aramaKelimesi + "%'", baglanti);

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(komut3);
            DataSet ds = new DataSet();
            da.Fill(ds);

            // Veri setinde eşleşme bulunup bulunmadığını kontrol et
            if (ds.Tables[0].Rows.Count > 0)
            {
                dataGridView1.DataSource = ds.Tables[0];
                TxtAdi.Clear();
                MessageBox.Show("Kişi arama işlemi başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Stop);
            }
            else
            {
                MessageBox.Show("Bu isimde biri listede eslesmiyor.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

            baglanti.Close();
        }


        private void BtnSil_Click(object sender, EventArgs e)
        {
            try
            {
                // Silme işlemi
                baglanti.Open();
                NpgsqlCommand komut = new NpgsqlCommand("DELETE FROM public.\"Kisi\" WHERE \"TcKimlikNo\"=@p1", baglanti);
                komut.Parameters.AddWithValue("@p1", long.Parse(TxtTcNo.Text));
                komut.ExecuteNonQuery();
                baglanti.Close();

                // Kullanıcıya onay mesajı gösterme
                DialogResult result = MessageBox.Show("Silme işlemi onaylıyor musunuz?", "Bilgi", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    // Silme işlemi onaylandıysa, DataGridView'i güncelle
                    BtnListele_Click(sender, e);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message, "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnGuncelle_Click(object sender, EventArgs e)
        {
            double x = double.Parse(comboBox1.SelectedItem.ToString());
            double y = x / 10000;

            try
            {
                baglanti.Open();

                // Girilen Tc Kimlik Numarasının mevcut olup olmadığını kontrol et
                NpgsqlCommand kontrolKomut = new NpgsqlCommand("SELECT COUNT(*) FROM public.\"Kisi\" WHERE \"TcKimlikNo\" = @p1", baglanti);
                kontrolKomut.Parameters.AddWithValue("@p1", long.Parse(TxtTcNo.Text));
                int kayitSayisi = Convert.ToInt32(kontrolKomut.ExecuteScalar());

                if (kayitSayisi > 0)
                {
                    // Tc Kimlik Numarası mevcutsa güncelleme işlemine devam et
                    NpgsqlCommand guncelleKomut = new NpgsqlCommand("UPDATE public.\"Kisi\" SET \"Ad\"=@p1, \"Soyad\"=@p2, \"TelefonNo\"=@p3, \"Cinsiyet\"=@p5, \"AdresKoordinat\"=@p6, \"Yetkili\"=@p7, \"Vatandas\"=@p8 WHERE \"TcKimlikNo\"=@p4", baglanti);
                    guncelleKomut.Parameters.AddWithValue("@p1", TxtAdi.Text);
                    guncelleKomut.Parameters.AddWithValue("@p2", TxtSoyadi.Text);
                    guncelleKomut.Parameters.AddWithValue("@p3", long.Parse(TxtTelNo.Text));
                    guncelleKomut.Parameters.AddWithValue("@p4", long.Parse(TxtTcNo.Text));
                    guncelleKomut.Parameters.AddWithValue("@p5", comboBox2.Text); 
                    guncelleKomut.Parameters.AddWithValue("@p6", y); 
                    guncelleKomut.Parameters.AddWithValue("@p7", checkBox1.Checked);
                    guncelleKomut.Parameters.AddWithValue("@p8", checkBox2.Checked);
                    guncelleKomut.ExecuteNonQuery();

                    MessageBox.Show("Güncelleme işlemi başarılı oldu", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    MessageBox.Show("Girilen Tc Kimlik Numarası mevcut değil. Lütfen tabloda olan bir Tc Kimlik Numarası giriniz.", "Uyarı", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message, "Hata", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                baglanti.Close();
            }
            RefreshList();
        }
        private void RefreshList()
        {
            baglanti.Open();
            string sorgu = "select * from public.\"Kisi\"";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            baglanti.Close();
        }
    }
}



