namespace lets_invest_api.Dto
{
    using lets_invest_api.Models;
    public class CreatePortfolioDto
    {
        public bool IsPublic { get; set; }

        public double Value { get; set; }

        public double Cash { get; set; }
        
        public List<CreateStockDto> stocks { get; set; }
        
        public List<Crypto> cryptos { get; set; }
    }
}
