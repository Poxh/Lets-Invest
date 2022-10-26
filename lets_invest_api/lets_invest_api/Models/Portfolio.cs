namespace lets_invest_api.Models
{
    public class Portfolio
    {
        public int Id { get; set; }

        public bool IsPublic { get; set; }

        public double Cash { get; set; }

        public ICollection<Stock> Stocks { get; set; }
        
        public ICollection<Crypto> Cryptos { get; set; }

        public User User { get; set; }

        public int UserId { get; set; }
    }
}
