namespace lets_invest_api.Models
{
    public class Portfolio
    {
        public int Id { get; set; }

        public bool IsPublic { get; set; }

        public double Value { get; set; }

        public double Cash { get; set; }

        public List<Stock> Stocks { get; set; }
        public List<Crypto> Cryptos { get; set; }

        public User User { get; set; }

        public int UserId { get; set; }
    }
}
