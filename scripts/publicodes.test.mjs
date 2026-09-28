import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import vm from 'node:vm';
import test from 'node:test';

const bundle = await readFile(new URL('../assets/js/publicodes_bundle.js', import.meta.url), 'utf8');
const rules = await readFile(new URL('../assets/data/rules.json', import.meta.url), 'utf8');
const context = vm.createContext({ console });
vm.runInContext(bundle, context);
const call = (name, value) => {
  const result = JSON.parse(context[name](value));
  if (result.error) throw new Error(result.error);
  return result.data;
};

test('uninitialized or invalid engine never reports a zero score', () => {
  assert.throws(() => call('getBilan', 'bilan'), /initialized/);
  assert.throws(() => call('initEngine', '{broken'), /JSON|property/);
});
test('bundled rules yield a positive total and finite categories', () => {
  assert.equal(call('initEngine', rules), true);
  assert.equal(call('updateSituation', '{}'), true);
  const total = call('getBilan', 'bilan');
  assert.ok(total > 1000 && total < 50000, `baseline: ${total}`);
  const parts = ['transport', 'logement', 'alimentation', 'divers', 'services sociétaux']
    .map(category => call('getBilan', category));
  assert.ok(parts.every(value => Number.isFinite(value) && value >= 0));
  assert.ok(Math.abs(parts.reduce((a, b) => a + b, 0) - total) < 1);
});
test('answers change the result and resetting removes the previous situation', () => {
  const baseline = call('getBilan', 'bilan');
  call('updateSituation', JSON.stringify({ 'transport . voiture . utilisateur': "'jamais'" }));
  assert.ok(call('getBilan', 'bilan') < baseline);
  call('updateSituation', '{}');
  assert.equal(call('getBilan', 'bilan'), baseline);
});
test('invalid objectives and situations propagate errors', () => {
  assert.throws(() => call('getBilan', 'unknown objective'));
  assert.throws(() => call('updateSituation', '{invalid'));
  assert.ok(Array.isArray(call('checkApplicability', 'bilan')));
});
