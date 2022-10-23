using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lets_invest_api.Models
{
    public class User
    {
        public int Id { get; set; }

        public string DisplayName { get; set; } = null!;

        public string Email { get; set; } = null!;

        public int Follower { get; set; }

        public int Activities { get; set; }

        public Portfolio Portfolio { get; set; } = null!;
    }
}
