local m = {
	"[Discord] Visite nosso discord para mais noticias: discord.gg/UU5jXFn4w3",
	"[Download] O Servidor atualmente se encontra na vers�o 1.5.5, caso n�o esteja usando essa vers�o, por favor, entre em www.pokemoneternium.com.br e baixe.",
	"[Promo��o] Passe de batalha do m�s de MAIO liberado, informa��es no nosso site: www.pokemoneternium.com.br, Caso queira aderir, contate o admin via whatsapp: 21988402239.",
}

function onThink()
	doBroadcastMessage("[Broadcast Automatico]: ".. m[math.random(1,#m)])
	return TRUE
end