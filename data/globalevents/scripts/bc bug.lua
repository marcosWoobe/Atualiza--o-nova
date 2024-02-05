local m = {
	"[Discord] Visite nosso discord para mais noticias: discord.gg/UU5jXFn4w3",
	"[Download] O Servidor atualmente se encontra na versão 1.5.5, caso não esteja usando essa versão, por favor, entre em www.pokemoneternium.com.br e baixe.",
	"[Promoção] Passe de batalha do mês de MAIO liberado, informações no nosso site: www.pokemoneternium.com.br, Caso queira aderir, contate o admin via whatsapp: 21988402239.",
}

function onThink()
	doBroadcastMessage("[Broadcast Automatico]: ".. m[math.random(1,#m)])
	return TRUE
end