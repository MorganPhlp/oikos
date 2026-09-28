// Shared by the browser and the mobile JavaScript runtime.
let engine;
const reply = (operation) => {
  try { return JSON.stringify({ data: operation() }); }
  catch (error) { return JSON.stringify({ error: error.message }); }
};
globalThis.initEngine = (rules) => reply(() => {
  engine = new module.exports.default(JSON.parse(rules), {
    logger: { log() {}, warn() {}, error() {} },
  });
  return true;
});
const requireEngine = () => {
  if (!engine) throw new Error('Publicodes has not been initialized');
  return engine;
};
globalThis.updateSituation = (situation) => reply(() => {
  const values = Object.fromEntries(Object.entries(JSON.parse(situation))
    .filter(([, value]) => value !== null));
  requireEngine().setSituation(values);
  return true;
});
globalThis.getBilan = (objective) => reply(() => {
  const value = requireEngine().evaluate(objective).nodeValue;
  if (typeof value !== 'number' || !Number.isFinite(value) || value < 0) {
    throw new Error(`Invalid score for ${objective}`);
  }
  return value;
});
globalThis.checkApplicability = (objective) => reply(() =>
  Object.keys(requireEngine().evaluate(objective).missingVariables || {}));
