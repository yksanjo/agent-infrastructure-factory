/**
 * hr-connectors
 * connectors for HR & Recruiting
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'hr-connectors';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'hr',
      package: 'connectors',
      task,
    };
  }
}

export default Agent;
