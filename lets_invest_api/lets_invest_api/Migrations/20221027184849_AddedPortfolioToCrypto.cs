using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace lets_invest_api.Migrations
{
    public partial class AddedPortfolioToCrypto : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos");

            migrationBuilder.AlterColumn<int>(
                name: "PortfolioId",
                table: "Cryptos",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos",
                column: "PortfolioId",
                principalTable: "Portfolios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos");

            migrationBuilder.AlterColumn<int>(
                name: "PortfolioId",
                table: "Cryptos",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Cryptos_Portfolios_PortfolioId",
                table: "Cryptos",
                column: "PortfolioId",
                principalTable: "Portfolios",
                principalColumn: "Id");
        }
    }
}
