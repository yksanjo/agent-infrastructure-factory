/**
 * legal-core-agents
 * core-agents for Legal Tech
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'legal-core-agents';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'legal',
      package: 'core-agents',
      task,
    };
  }
}

export default Agent;
