/**
 * supply-core-agents
 * core-agents for Supply Chain
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'supply-core-agents';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'supply',
      package: 'core-agents',
      task,
    };
  }
}

export default Agent;
