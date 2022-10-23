using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lets_invest_api.Models
{
    public class Portfolio
    {
        public int Id { get; set; }

        public bool isPublic { get; set; }

        public ICollection<Stock> Stocks { get; set; }

        public User User { get; set; } = null!;
    }
}
