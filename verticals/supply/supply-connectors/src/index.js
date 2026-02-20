/**
 * supply-connectors
 * connectors for Supply Chain
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'supply-connectors';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'supply',
      package: 'connectors',
      task,
    };
  }
}

export default Agent;
