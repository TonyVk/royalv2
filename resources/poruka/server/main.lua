function SaljiPoruku()
	TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 113, 0, 0.6); border-radius: 3px;"><i class="fas fa-info"></i> {0}:<br> {1}</div>',
            args = { "Informacije", "Restart servera je svaki dan u 12 i 18 sati!" }
	})
	SetTimeout(600000, SaljiPoruku)
end

SaljiPoruku()