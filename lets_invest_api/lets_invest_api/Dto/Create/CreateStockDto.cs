namespace lets_invest_api.Dto;

public class CreateStockDto
{
    public int PortfolioId { get; set; }
    
    public int Id { get; set; }
    
    public string Name { get; set; }
        
    public string Isin { get; set; }

    public double Quantity { get; set; }

    public DateTime BoughtAt { get; set; } = DateTime.UtcNow;
}