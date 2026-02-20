/**
 * hr-core-agents
 * core-agents for HR & Recruiting
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'hr-core-agents';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'hr',
      package: 'core-agents',
      task,
    };
  }
}

export default Agent;
