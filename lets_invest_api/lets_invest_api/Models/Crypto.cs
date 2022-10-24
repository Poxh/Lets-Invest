namespace lets_invest_api.Models
{
    public class Crypto
    {
        public int Id { get; set; }
        
        public string Name { get; set; }
        
        public string Isin { get; set; }

        public double Quantity { get; set; }

        public DateTime BoughtAt { get; set; } = DateTime.UtcNow;
    }
}
