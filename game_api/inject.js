module.exports = function(dependencies) {
  dependencies = dependencies || {};
  const injector = function(dependencyName) {
    if (!dependencies[dependencyName]) {
      throw new Error('Required dependency <' + dependencyName + '> is not provided.');
    }
    return dependencies[dependencyName];
  };
  return injector;
};
