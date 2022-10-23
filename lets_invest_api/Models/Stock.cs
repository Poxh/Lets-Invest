using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lets_invest_api.Models
{
    public class Stock
    {
        public int Id { get; set; }

        public string Isin { get; set; } = null!;

        public string Name { get; set; } = null!;

        public double price { get; set; }

        public double quantity { get; set; }

        public DateTime boughtAt { get; set; }
    }
}
