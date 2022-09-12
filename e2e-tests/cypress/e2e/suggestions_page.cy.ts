describe('Suggestions page', () => {
	it('should display three recipes', () => {
		cy.visit('http://localhost:4000')
		cy.findByRole('list', { name: /Suggestions de recettes/i }).within(($list) => {
			cy.findAllByRole('listitem').should('have.length', 3)
		})
	})
})
