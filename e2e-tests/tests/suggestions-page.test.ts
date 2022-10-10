import { test, expect, Page } from '@playwright/test';
import type { Locator } from '@playwright/test';

test.beforeEach(({ page }) => {
  page.goto('http://localhost:4000');
})

test('Suggestions page', async ({ page }) => {
  const suggestionsWrapperLocator = page.getByRole('list', { name: /Suggestions de recettes/i })
  const recipeSuggestions = await getAllByRole(suggestionsWrapperLocator, 'listitem')
  await recipeSuggestions.first().waitFor()

  expect(await recipeSuggestions.count()).toEqual(3);
});

type Role = Parameters<Page['getByRole']>[0];

async function getAllByRole(parent: Page|Locator, role: Role, name?: string): Promise<Locator> {
  const locator = parent.getByRole(role, { name });
  await locator.first().waitFor();
  return locator;
}
